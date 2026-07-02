{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  cctools,
  go-toml,
  ttfautohint-nox,
  # Custom font set options.
  # See https://typeof.net/Iosevka/customizer
  # Can be a raw TOML string, or a Nix attrset.

  # Ex:
  # privateBuildPlan = ''
  #   [buildPlans.iosevka-custom]
  #   family = "Iosevka Custom"
  #   spacing = "normal"
  #   serifs = "sans"
  #
  #   [buildPlans.iosevka-custom.variants.design]
  #   capital-j = "serifless"
  #
  #   [buildPlans.iosevka-custom.variants.italic]
  #   i = "tailed"
  # '';

  # Or:
  # privateBuildPlan = {
  #   family = "Iosevka Custom";
  #   spacing = "normal";
  #   serifs = "sans";
  #
  #   variants = {
  #     design.capital-j = "serifless";
  #     italic.i = "tailed";
  #   };
  # }
  privateBuildPlan ? null,
  # Extra parameters. Can be used for ligature mapping.
  # It must be a raw TOML string.

  # Ex:
  # extraParameters = ''
  #   [[iosevka.compLig]]
  #   unicode = 57808 # 0xe1d0
  #   featureTag = 'XHS0'
  #   sequence = "+>"
  # '';
  extraParameters ? null,
  # Custom font set name. Required if `extraParameters` is used and/or
  # if `privateBuildPlan` is a TOML string.
  set ? privateBuildPlan.family or null,
}:

assert (builtins.isAttrs privateBuildPlan) -> builtins.hasAttr "family" privateBuildPlan;
assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;

buildNpmPackage rec {
  pname = "Iosevka${toString set}";
  version = "34.7.0";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    tag = "v${version}";
    hash = "sha256-OwCtp/WufMCzuaPTDCr2siorUC52zgM2e80DyshzsZw=";
  };

  npmDepsHash = "sha256-tlBxO9K0itXO6Mac4jcygZ6+9kj1gTdmu+rtbL2qdcE=";

  nativeBuildInputs = [
    go-toml
    ttfautohint-nox
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # libtool
    cctools
  ];

  strictDeps = true;

  buildPlan =
    if builtins.isAttrs privateBuildPlan then
      builtins.toJSON { buildPlans.${pname} = privateBuildPlan; }
    else
      privateBuildPlan;

  inherit extraParameters;

  configurePhase = ''
    runHook preConfigure
    ${lib.optionalString (builtins.isAttrs privateBuildPlan) ''
      printf "%s" "$buildPlan" | jsontoml -use-json-number > private-build-plans.toml
    ''}
    ${lib.optionalString
      (builtins.isString privateBuildPlan && (!lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        printf "%s" "$buildPlan" > private-build-plans.toml
      ''
    }
    ${lib.optionalString
      (builtins.isString privateBuildPlan && (lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlan" private-build-plans.toml
      ''
    }
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> params/parameters.toml
      printf "%s" "$extraParameters" >> params/parameters.toml
    ''}
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild

    # pipe to cat to disable progress bar
    npm run build --no-update-notifier --targets ttf::"$pname" -- --jCmd=$NIX_BUILD_CORES --verbosity=9 | cat

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install "dist/$pname/TTF"/* "$fontdir"
    runHook postInstall
  '';

  enableParallelBuilding = true;
  requiredSystemFeatures = [ "big-parallel" ];

  __structuredAttrs = true;

  meta = {
    homepage = "https://typeof.net/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = "Versatile typeface for code, from code";
    longDescription = ''
      Iosevka is an open-source, sans-serif + slab-serif, monospace +
      quasi‑proportional typeface family, designed for writing code, using in
      terminals, and preparing technical documents.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      lunik1
    ];
  };
}
