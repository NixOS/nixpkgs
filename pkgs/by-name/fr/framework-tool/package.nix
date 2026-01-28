{
  config,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  autoAddDriverRunpath,
  enableNVML ? config.cudaSupport,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-wgleuZ0txkmv0+tyr31PiVTNyTSc+OPy/jJwL1Ryyu4=";
  };

  cargoHash = "sha256-W+k/PAcdwl9mvajB9D4SUH4o5VqpeD/BnK6ZEJzPpmI=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (lib.optionals enableNVML [
    autoAddDriverRunpath
  ]);

  buildFeatures = lib.optionals enableNVML [
    "nvidia"
  ];

  buildInputs = [ udev ];

  postFixup = lib.optionalString enableNVML ''
    patchelf --add-needed libnvidia-ml.so "$out/bin/framework_tool"
  '';

  meta = {
    description = "Swiss army knife for Framework laptops";
    homepage = "https://github.com/FrameworkComputer/framework-system";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      nickcao
      leona
      kloenk
      johnazoidberg
    ];
    mainProgram = "framework_tool";
  };
}
