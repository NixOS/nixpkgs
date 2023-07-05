{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, maven
, wrapGAppsHook
, jre
, libXtst
}:
let
  pname = "quark-goldleaf";
  version = "0.10.1";

  description = "A GUI tool to help Goldleaf with file-transfer between the Nintendo Switch and the PC";

  configDir = "\${XDG_CONFIG_HOME:-~/.config}/${pname}";

  goldleafSrc = fetchFromGitHub {
    owner = "XorTroll";
    repo = "Goldleaf";
    rev = "refs/tags/${version}";
    sha256 = "sha256-Kq9IkkPJgPCdTBWlpqz2AexYqp6auFnsy/hV/n980VQ=";
  };

  quarkUnwrapped = maven.buildMavenPackage {
    pname = "${pname}-unwrapped";
    inherit version;

    src = goldleafSrc + "/Quark";
    mvnHash = "sha256-eqe2NqtCC6aJg5kptKqd0wUlM7/FHDsEH48H1RHGzT0=";

    nativeBuildInputs = [
      makeWrapper
      maven
      wrapGAppsHook
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
    install -Dm644 ${./switch.rules} $out/etc/udev/rules.d/99-switch.rules
    # If wrapGAppsHook was used here, this wouldn't work properly
    makeWrapper ${quarkUnwrapped}/bin/${pname} $out/bin/${pname} \
          --run "mkdir -p ${configDir}" \
          --append-flags "-cfgfile ${configDir}/quark.cfg"
          '';

  meta = with lib; {
    inherit description;
    homepage = "https://github.com/XorTroll/Goldleaf/blob/master/Quark.md";
    longDescription = ''
      ${description}

      For it to work properly, you need to install the Nintendo Switch udev rules by adding

      `services.udev.packages = [ pkgs.${pname} ]`

      to your NixOS configuration
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.tomasajt ];
  };
}
