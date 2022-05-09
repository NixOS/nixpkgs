{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, ant
, openjdk8
, postgresqlSupport ? false
, postgresql
, libarchive
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "osrmt";
  version = "unstable-2020-04-24";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "b4909cd81e53244c15fe4e1a9218a91e37f2965a";
    sha256 = "sha256-MS8CkuhXrwaQqJKcNL9tDybZ/YdNpINaR5mT35xRTFs=";
  };

  nativeBuildInputs = [
    ant
    libarchive
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    openjdk8
  ] ++ lib.optional postgresqlSupport postgresql;

  patches = [
    (fetchpatch {
      name = "add-shebang.patch";
      url = "https://github.com/yuuyins/osrmt/commit/6ef27fa22428873ce0890e469c33cb5167e2f832.patch";
      sha256 = "sha256-psS1nUVKARsn0SDNAYczUDHEAz7obKXVz79arExODG8=";
    })
  ];

  postPatch = ''
    substituteInPlace ./build-resources/appclient/resources/run.sh --replace "java" "${openjdk8}/bin/java"
    substituteInPlace ./build-resources/appclient/resources/run3tier.sh --replace "java " "${openjdk8}/bin/java "
    substituteInPlace ./build-resources/db-init/app-client/upgrade.sh --replace "java" "${openjdk8}/bin/java"
  '';

  buildPhase = ''
    # Desktop application build.
    # After build finishes assembling the application,
    # OSRMT will be available in the 'dist' folder.
    ant app.client.assemble
  '';

  installPhase = ''
    install -d $out/bin $out/opt

    bsdtar --extract --file $NIX_BUILD_TOP/${src.name}/dist/osrmt.desktop.zip --directory $out/opt
    chmod +x $out/opt/run.sh $out/opt/run3tier.sh $out/opt/upgrade.sh
    # ln -s $out/opt/run.sh $out/bin/osrmt

    for jar in $out/opt/*.jar; do
      classpath="''${classpath-}''${classpath:+:}''${jar}"
    done

    makeWrapper ${openjdk8}/bin/java $out/bin/osrmt \
      --chdir $out/opt \
      --prefix _JAVA_OPTIONS : "-Dawt.useSystemAAFontSettings=on" \
      --add-flags "-Duser.dir=$out/opt -classpath \"$classpath\" com.osrmt.appclient.reqmanager.RequirementManagerController"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "osrmt";
      desktopName = "OSRMT";
      genericName = "Open source requirements management tool";
      exec = "osrmt";
      icon = "osrmt";
      comment = meta.description;
      categories = [ "Development" "Education" "ComputerScience" "Engineering" "Java" ];
    })
  ];

  meta = with lib; {
    description = "Requirements specification and management tool";
    homepage = "https://github.com/osrmt/osrmt";
    changelog = "https://github.com/osrmt/osrmt/releases";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ yuu ];
  };
}
