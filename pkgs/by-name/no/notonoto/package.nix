{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  fontforge,
  python3,
  width35 ? false,
  console ? false,
  hideZenkakuSpace ? false,
}:

let
  python3' = python3.withPackages (
    ps: with ps; [
      fonttools
      ttfautohint-py
    ]
  );
  fontforgeArgs =
    lib.optional width35 "--35"
    ++ lib.optional console "--console"
    ++ lib.optional hideZenkakuSpace "--hidden-zenkaku-space";
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname =
    "notonoto"
    + lib.optionalString hideZenkakuSpace "-hs"
    + lib.optionalString width35 "-35"
    + lib.optionalString console "-console";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "yuru7";
    repo = "NOTONOTO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1dbx4yC8gL41OEAE/LNDyoDb4xhAwV5h8oRmdlPULUo=";
  };

  # ttfautohint: unrecognized option '--epoch'
  postPatch = ''
    substituteInPlace fonttools_script.py \
      --replace-fail 'print("exec hinting", options_)' 'options_.pop("epoch", None)' \
      --replace-fail 'fix_cmap_table(xml, style, variant)' \
                     'pass  # FontTools >= 4.58.1 already preserves cmap format 14'
  '';

  nativeBuildInputs = [
    fontforge
    python3'
  ];

  buildPhase = ''
    runHook preBuild

    fontforge --script fontforge_script.py ${lib.escapeShellArgs fontforgeArgs}
    python3 ./fonttools_script.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/*.ttf -t $out/share/fonts/truetype/${finalAttrs.pname}

    runHook postInstall
  '';

  meta = {
    description = "Programming font that combines Noto Sans Mono and Noto Sans JP";
    homepage = "https://github.com/yuru7/NOTONOTO";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ genga898 ];
    platforms = lib.platforms.all;
  };
})
