{
  lib,
  fetchFromGitLab,
  writeText,
  sbcl,
  asdf,
}:
sbcl.buildASDFSystem rec {
  pname = "jhide";
  version = "0.1.0-unstable-2021-05-01";

  src = fetchFromGitLab {
    owner = "jgkamat";
    repo = pname;
    rev = "93f364a39c326620d5a2c7a598af0f6967c47ae5";
    hash = "sha256-iuuuXUSz9rhv1kYCQ+FewegWUaVdjvO8S4uo4R5pV1Y=";
  };

  lispLibs = with sbcl.pkgs; [
    parenscript
    str
    unix-opts
    alexandria
    arrow-macros
    cl-json
  ];

  buildScript = writeText "build-jhide.lisp" ''
    (load "${asdf}/lib/common-lisp/asdf/build/asdf.lisp")

    (asdf:load-system 'jhide)

    ;; Prevents "cannot create /homeless-shelter" error
    (asdf:disable-output-translations)

    (sb-ext:save-lisp-and-die
      "jhide"
      :purify t
      #+sb-core-compression :compression
      #+sb-core-compression t
      :executable t

      ;; Prevent --help from being intercepted by sbcl
      :save-runtime-options t

      :toplevel #'jhide:main)
  '';

  flags = [
    "--noinform"
    "--non-interactive"
    "--end-toplevel-options"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp jhide $out/bin
  '';

  meta = {
    description = "Tool for creating Greasemonkey scripts from AdBlock Plus element filtering lists";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ somasis ];
    mainProgram = pname;
  };
}
