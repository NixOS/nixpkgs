{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fortify-headers";
  version = "1.1";

  # upstream only accessible via git - unusable during bootstrap, hence
  # extract from GitHub release.
  src = fetchurl {
    url = "https://github.com/jvoisin/fortify-headers/archive/refs/tags/${finalAttrs.version}.tar.gz";
    hash = "sha256-3WJbFTjsIeL7fuFTTEoTaPAyz6PQ2sLBK29mQ8YG+1Y=";
  };

  patches = [
    (fetchurl {
      # Remove when updating to >= 3.0
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/4adfa7e7291a716b871969b9d1146db037009b57/main/fortify-headers/0001-add-initial-clang-support.patch";
      hash = "sha256-QbDnMTGVmvIokow6lkA+mDHFMDP8B0lLY8w9ciUhGKU=";
    })
    (fetchurl {
      # Remove when updating to >= 3.0
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/4adfa7e7291a716b871969b9d1146db037009b57/main/fortify-headers/0002-avoid-__extension__-with-clang.patch";
      hash = "sha256-LooU8I5td7fsfXjBahawvZbhR7r9HTWlT7qGbPE88zY=";
    })
    (fetchurl {
      # Remove when updating to >= 3.0
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/4adfa7e7291a716b871969b9d1146db037009b57/main/fortify-headers/0003-Disable-wrapping-of-ppoll.patch";
      hash = "sha256-NW46jwkKS/0hvC7WFaetbAyQxf/YLnyEV+Y8G9payCw=";
    })
    ./wchar-imports-skip.patch
    ./restore-macros.patch
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r include $out/include

    runHook postInstall
  '';

  meta = {
    description = "Standalone header-based fortify-source implementation";
    homepage = "https://git.2f30.org/fortify-headers";
    license = lib.licenses.bsd0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
})
