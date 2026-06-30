{
  mumble,
  stdenv_32bit,
}@args:

mumble.override (
  {
    type = "mumble-overlay";
    stdenv = stdenv_32bit;
  }
  // removeAttrs args [
    "mumble"
    "stdenv_32bit"
  ]
)
