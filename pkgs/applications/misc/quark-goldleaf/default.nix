{ lib
, stdenv
, maven
, fetchFromGitHub
, wrapGAppsHook
, makeWrapper
, jre
, libXtst
}:
let
  pname = "quark-goldleaf";
  version = "0.10.1";

  mvnHashes = {
    x86_64-linux = "sha256-Yt39Lj1LGpobXepa8S3gvhphU1fE1gWSPB+k/bgc9wk=";
    aarch64-linux = "sha256-Yt39Lj1LGpobXepa8S3gvhphU1fE1gWSPB+k/bgc9wk=";
    x86_64-darwin = "sha256-Yt39Lj1LGpobXepa8S3gvhphU1fE1gWSPB+k/bgc9wk=";
    aarch64-darwin = "sha256-Yt39Lj1LGpobXepa8S3gvhphU1fE1gWSPB+k/bgc9wk=";
  };

  quarkUnwrapped = maven.buildMavenPackage {
    pname = "${pname}-half-wrapped";
    inherit version;

    src = fetchFromGitHub {
      owner = "XorTroll";
      repo = "Goldleaf";
      rev = "refs/tags/${version}";
      sha256 = "sha256-Kq9IkkPJgPCdTBWlpqz2AexYqp6auFnsy/hV/n980VQ=";
    };
    sourceRoot = "source/Quark";

    mvnHash = mvnHashes.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

    nativeBuildInputs = [
      wrapGAppsHook
      makeWrapper
    ];

    installPhase = ''
      install -D target/Quark.jar $out/share/java/${pname}.jar
      makeWrapper ${jre}/bin/java $out/bin/${pname} \
            --add-flags "-jar $out/share/java/${pname}.jar" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libXtst ]}"
    '';
  };
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${./switch.rules} $out/etc/udev/rules.d/99-switch.rules
    # If wrapGAppsHook was used here, ~ wouldn't work properly
    makeWrapper ${quarkUnwrapped}/bin/${pname} $out/bin/${pname} \
    --append-flags "-cfgfile ~/.quark.cfg"

    runHook postInstall
  '';

  meta = rec {
    homepage = "https://github.com/XorTroll/Goldleaf/blob/master/Quark.md";
    changelog = "https://github.com/XorTroll/Goldleaf/releases/tag/${version}";
    description = "A GUI tool to help Goldleaf with file-transfer between the Nintendo Switch and the PC";
    longDescription = ''
      ${description}

      For it to work properly, you need to install the Nintendo Switch udev rules.

      On NixOS you can do this by adding the following to your configuration:

      `services.udev.packages = [ pkgs.${pname} ]`
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.attrNames mvnHashes;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
