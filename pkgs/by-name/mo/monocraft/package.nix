{ stdenvNoCC, lib, fetchurl }:

let
  version = "4.0";
  relArtifact = name: hash: fetchurl {
    inherit name hash;
    url = "https://github.com/IdreesInc/Monocraft/releases/download/v${version}/${name}";
  };
in
stdenvNoCC.mkDerivation {
  pname = "monocraft";
  inherit version;

  srcs = [
    (relArtifact "Monocraft.ttc" "sha256-SBzl/X2PQOq1cY4dlqO89BDwCrP+/LYwZ9X24p2LDCs=")
    (relArtifact "Monocraft-no-ligatures.ttc" "sha256-jFZ5Fr/cBwGVsdy7lPqLiLlKtzjF5OIWVkwZI6gR3W4=")
    (relArtifact "Monocraft-nerd-fonts-patched.ttc" "sha256-lYAb8hgmv4VyrzeHr4LnfuSN9L+4fpDEMX/P++fq8Dc=")
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    for src in "''${srcs[@]}"
    do
      install -Dm644 --target $out/share/fonts/truetype $src
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming font based on the typeface used in Minecraft";
    homepage = "https://github.com/IdreesInc/Monocraft";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
