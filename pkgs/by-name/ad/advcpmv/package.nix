{
  lib,
  coreutils,
}:

coreutils.overrideAttrs (oldAttrs: {
  pname = "advcpmv";

  patches = oldAttrs.patches ++ [
    ./advcpmv.patch
  ];

  meta = oldAttrs.meta // {
    homepage = "https://github.com/jarun/advcpmv";
    description = "GNU Coreutils cp and mv with progress bar support";
    longDescription = ''
      Advanced copy and move (advcpmv) provides the classic GNU Coreutils
      cp and mv utilities with an added progress bar feature. When the
      -g/--progress-bar option is used, a real-time progress indicator
      shows transfer speed, percentage complete, estimated time remaining,
      and other useful information during file operations.

      This is particularly useful when copying or moving large files or
      directories, providing visual feedback about the operation's progress.
    '';
    maintainers = with lib.maintainers; [ ];
  };
})
