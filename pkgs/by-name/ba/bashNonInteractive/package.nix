{
  lib,
  bash,
}:

lib.lowPrio (bash.override { interactive = false; })
