{
  open-vm-tools,
  ...
}@args:

open-vm-tools.override (
  {
    withX = false;
  }
  // removeAttrs args [ "open-vm-tools" ]
)
