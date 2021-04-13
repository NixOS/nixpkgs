..
| select(type == "object" and .type == "disk" and (.children | length > 0))
| (
  . as $disk
  | .children
  | map(
    .disk_path = $disk.path
    | .disk_kname = $disk.kname
  )
)
| .[]
| select(.fstype == "zfs_member")
| {
  part_path: ("/sys/block/" + .disk_kname + "/" + .kname + "/partition"),
  disk_path: .disk_path
}
