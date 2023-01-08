{ lib
, trivialBuild
, fetchFromGitHub
, python310Packages
, python310
, posframe
, markdown-mode
, yasnippet
, org
, which-key
, makeWrapper
}:

let
  rev = "7dfeeb640d14697755e2ac7997af0ec6c413197f";
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

  patches = [ ./wrapper.patch ];
  
  packageRequires = 
    [
      posframe
      markdown-mode
      yasnippet
      org
      which-key
    ];

  buildInputs =
    [
      (python310.withPackages (ps: with ps; [ epc orjson sexpdata six ]))
      makeWrapper
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

  postInstall = with python310Packages; ''
          wrapProgram $out/share/emacs/site-lisp/lsp_bridge.py \
              --prefix PYTHONPATH : "${python310}" \
              --prefix PYTHONPATH : "${epc}" \
              --prefix PYTHONPATH : "${orjson}" \
              --prefix PYTHONPATH : "${sexpdata}" \
              --prefix PYTHONPATH : "${six}";
         '';
  
  meta = {
    description = "Lsp-bridge's goal is to become the fastest LSP client in Emacs.";
    longDescription = ''
        Lsp-bridge uses python's threading technology to build caches that bridge Emacs and LSP server.
        Lsp-bridge will provide smooth completion experience without compromise to slow down emacs' performance.
      '';
    license = lib.licenses.gpl3;
  };
}
