{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  python3,
  ttfautohint-nox,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "eb-garamond";
  version = "0.016";

  src = fetchFromGitHub {
    owner = "georgd";
    repo = "EB-Garamond";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ajieKhTeH6yv2qiE2xqnHFoMS65//4ZKiccAlC2PXGQ=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [
    installFonts
    (python3.withPackages (p: [ p.fontforge ]))
    ttfautohint-nox
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "@\$(SFNTTOOL) -w \$< \$@"   "@fontforge -lang=ff -c 'Open(\$\$1); Generate(\$\$2)' \$< \$@"
  '';

  buildPhase = ''
    runHook preBuild
    make WEB=build EOT="" all
    runHook postBuild
  '';

  # installFonts adds a hook to `postInstall` that installs fonts
  # into the correct directories
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with lib.maintainers; [
      bengsparks
      relrod
      rycee
    ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
