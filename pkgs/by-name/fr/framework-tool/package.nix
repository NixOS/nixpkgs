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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-tool";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${finalAttrs.version}";
    hash = "sha256-criNeQcbMAWA8q27GClzCncbcj/zhD7yJylQnnFKMS4=";
  };

  cargoHash = "sha256-sMhH/Qzc2Pf+hnKcCEmw37s8rLniqFnfZ72ptG8APOk=";

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
      kloenk
      johnazoidberg
    ];
    mainProgram = "framework_tool";
  };
})
