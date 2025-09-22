{
  lib,
  gn,
  melpaBuild,
}:

melpaBuild {
  pname = "gn-mode-from-sources";
  ename = "gn-mode";
  version = "0-unstable-${gn.version}";
  inherit (gn) src;

  files = ''("misc/emacs/gn-mode.el")'';

  # Fixes the malformed header error
  postPatch = ''
    substituteInPlace misc/emacs/gn-mode.el \
      --replace-fail ";;; gn-mode.el - " ";;; gn-mode.el --- "
  '';

  meta = {
    inherit (gn.meta) homepage license;
    maintainers = with lib.maintainers; [ rennsax ];
    description = "Major mode for editing GN files; taken from GN sources";
  };
}
