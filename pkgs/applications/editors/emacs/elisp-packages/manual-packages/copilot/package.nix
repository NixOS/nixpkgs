{
  lib,
  dash,
  editorconfig,
  f,
  fetchFromGitHub,
  jsonrpc,
  nodejs,
  s,
  melpaBuild,
  copilot-language-server,
}:
melpaBuild (finalAttrs: {
  pname = "copilot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "copilot-emacs";
    repo = "copilot.el";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UA0Ra3sYVFwY1xL8COhOG8dLwtMLiQ7Euq5tk6e8M1g=";
  };

  files = ''(:defaults "dist")'';

  postPatch = ''
    substituteInPlace copilot.el \
      --replace-fail "defcustom copilot-server-executable \"copilot-language-server\"" \
                     "defcustom copilot-server-executable \"${lib.getExe copilot-language-server}\""
  '';

  packageRequires = [
    dash
    editorconfig
    f
    jsonrpc
    s
  ];

  propagatedUserEnvPkgs = [ nodejs ];

  meta = {
    description = "Unofficial copilot plugin for Emacs";
    homepage = "https://github.com/copilot-emacs/copilot.el";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bbigras ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
})
