# Turns
#
#   {
#     "hello.aarch64-linux": "a",
#     "hello.x86_64-linux": "b",
#     "hello.aarch64-darwin": "c",
#     "hello.x86_64-darwin": "d"
#   }
#
# into
#
#   {
#     "hello": {
#       "linux": {
#         "aarch64": "a",
#         "x86_64": "b"
#       },
#       "darwin": {
#         "aarch64": "c",
#         "x86_64": "d"
#       }
#     }
#   }
#
# while filtering out any attribute paths that don't match this pattern
def expand_system:
  to_entries
  | map(
    .key |= split(".")
    | select(.key | length > 1)
    | .double = (.key[-1] | split("-"))
    | select(.double | length == 2)
  )
  | group_by(.key[0:-1])
  | map(
    {
      key: .[0].key[0:-1] | join("."),
      value:
        group_by(.double[1])
        | map(
          {
            key: .[0].double[1],
            value: map(.key = .double[0]) | from_entries
          }
        )
        | from_entries
    })
  | from_entries
  ;

# Transposes
#
#   {
#     "a": [ "x", "y" ],
#     "b": [ "x" ],
#   }
#
# into
#
#   {
#     "x": [ "a", "b" ],
#     "y": [ "a" ]
#   }
def transpose:
  [
    to_entries[]
    | {
      key: .key,
      value: .value[]
    }
  ]
  | group_by(.value)
  | map({
    key: .[0].value,
    value: map(.key)
  })
  | from_entries
  ;

# Computes the key difference for two objects:
# {
#   added: [ <keys only in the second object> ],
#   removed: [ <keys only in the first object> ],
#   changed: [ <keys with different values between the two objects> ],
# }
#
def diff($before; $after):
  {
    added: $after | delpaths($before | keys | map([.])) | keys,
    removed: $before | delpaths($after | keys | map([.])) | keys,
    changed:
      $before
      | to_entries
      | map(
        $after."\(.key)" as $after2
        | select(
          # Filter out attributes that don't exist anymore
          ($after2 != null)
          and
          # Filter out attributes that are the same as the new value
          (.value != $after2)
        )
        | .key
      )
  }
  ;

($before[0] | expand_system) as $before
| ($after[0] | expand_system) as $after
| .attrdiff = diff($before; $after)
| .rebuildsByKernel = (
  .attrdiff.changed
  | map({
    key: .,
    value: diff($before."\(.)"; $after."\(.)").changed
  })
  | from_entries
  | transpose
)
| .rebuildCountByKernel = (
  .rebuildsByKernel
  | with_entries(.value |= length)
  | pick(.linux, .darwin)
  | {
    linux: (.linux // 0),
    darwin: (.darwin // 0),
  }
)
| .labels = (
  .rebuildCountByKernel
  | to_entries
  | map(
    "10.rebuild-\(.key): " +
      if .value == 0 then
        "0"
      elif .value <= 10 then
        "1-10"
      elif .value <= 100 then
        "11-100"
      elif .value <= 500 then
        "101-500"
      elif .value <= 1000 then
        "501-1000"
      elif .value <= 2500 then
        "1001-2500"
      elif .value <= 5000 then
        "2501-5000"
      else
        "5000+"
      end
  )
)
