{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

stdenv.mkDerivation rec {
  pname = "juno";
  version = "0.0.3";

  srcs = [
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno.tar.xz";
      sha256 = "sha256-G/H5FZ6VSLHwtMtttRafvPFE2sd30FHbep/0i4dGfl8=";
    })
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-mirage.tar.xz";
      sha256 = "sha256-VU8uNH6T9FyOWgIfsGCCihnX3uHfOy6dXsANWKRPQ1c=";
    })
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-ocean.tar.xz";
      sha256 = "sha256-OeMXR0nE9aUmwAGfOAfbNP2Rgvv1u/2vj3LKb88mD1s=";
    })
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-palenight.tar.xz";
      sha256 = "sha256-DP3fKXYxUHpsw0msfPAZB3UtEa6CCOfqsabAmsmWq44=";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Juno* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
    runHook postInstall
  '';

  meta = with lib; {
    description = "GTK themes inspired by epic vscode themes";
    homepage = "https://github.com/EliverLara/Juno";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.gvolpe ];
  };
}
