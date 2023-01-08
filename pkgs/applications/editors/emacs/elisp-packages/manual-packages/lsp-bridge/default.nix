{ lib
, trivialBuild
, fetchFromGitHub
, python3Packages
, python3
, posframe
, markdown-mode
, yasnippet
, org
, which-key
, makeWrapper
}:

let
  rev = "7dfeeb640d14697755e2ac7997af0ec6c413197f";
  python = python3.withPackages (ps: with ps; [ epc orjson sexpdata six ]);
in trivialBuild {
  pname = "lsp-bridge";
  version = "20230104";

  commit = rev;

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
    sha256 = "sha256-sB5niigN0rdtqeprlZAJEKgAuQDkcUMbbL9yTnrdoLg=";
  };

  packageRequires =
    [
      posframe
      markdown-mode
      yasnippet
      org
      which-key
    ];

  buildPhase = ''
    runHook preInstall

    install -d $out/share/emacs/site-lisp/
    install *.el $out/share/emacs/site-lisp/
    install acm/*.el $out/share/emacs/site-lisp/
    install *.py $out/share/emacs/site-lisp/
    cp -r core $out/share/emacs/site-lisp/
    cp -r langserver $out/share/emacs/site-lisp/
    cp -r multiserver $out/share/emacs/site-lisp/
    cp -r resources $out/share/emacs/site-lisp/
    cp -r acm/icons $out/share/emacs/site-lisp/

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace lsp-bridge.el --replace '(defcustom lsp-bridge-python-command (if (memq system-type '"'"'(cygwin windows-nt ms-dos)) "python.exe" "python3")' '(defcustom lsp-bridge-python-command "${python.interpreter}"'
  '';

  meta = {
    description = "Fastest LSP client in Emacs.";
    longDescription = ''
        Using python's threading technology to build caches that bridge Emacs and LSP server.
      '';
    license = lib.licenses.gpl3;
  };
}
