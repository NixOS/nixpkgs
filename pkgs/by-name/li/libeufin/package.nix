{
  lib,
  stdenv,
  fetchgit,
  python3,
  jdk17_headless,
  gradle,
  makeWrapper,
}:

let
  customPython = python3.withPackages (p: [ p.setuptools ]);
in

stdenv.mkDerivation rec {
  pname = "libeufin";
  version = "0.11.3";

  src = fetchgit {
    url = "https://git.taler.net/libeufin.git/";
    rev = "v${version}";
    hash = "sha256-6bMYcpxwL1UJXt0AX6R97C0Orwqb7E+TZO2Sz1qode8=";
    fetchSubmodules = true;
    leaveDotGit = true; # Required for correct submodule fetching
    # Delete .git folder for reproducibility (otherwise, the hash changes unexpectedly after fetching submodules)
    # Save the HEAD short commit hash in a file so it can be retrieved later for versioning.
    postFetch = ''
      (
        cd $out
        git rev-parse --short HEAD > ./common/src/main/resources/HEAD.txt
        rm -rf .git
      )
    '';
  };

  patches = [
    # The .git folder had to be deleted. Read hash from file instead of using the git command.
    ./read-HEAD-hash-from-file.patch
    # Gradle projects provide a .module metadata file as artifact. This artifact is used by gradle
    # to download dependencies to the cache when needed, but do not provide the jar for the
    # offline installation for our build phase. Since we make an offline Maven repo, we have to
    # substitute the gradle deps for their maven counterpart to retrieve the .jar artifacts.
    ./use-maven-deps.patch
  ];

  preConfigure = ''
    cp build-system/taler-build-scripts/configure ./configure
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk17_headless}" ];
  gradleBuildTask = [
    "bank:installShadowDist"
    "nexus:installShadowDist"
  ];

  nativeBuildInputs = [
    customPython
    jdk17_headless
    gradle
    makeWrapper
  ];

  # # Tell gradle to use the offline Maven repository
  # buildPhase = ''
  #   gradle bank:installShadowDist nexus:installShadowDist --offline --no-daemon --init-script ${gradleInit}
  # '';

  installPhase = ''
    runHook preInstall

    make install-nobuild

    for exe in libeufin-nexus libeufin-bank ; do
      wrapProgram $out/bin/$exe \
        --set JAVA_HOME ${jdk17_headless.home} \
        --prefix PATH : $out/bin \
        --prefix PATH : ${lib.makeBinPath [ jdk17_headless ]} \

    done

    runHook postInstall
  '';

  # Tests need a database to run.
  # TODO there's a postgres runner thingy you could use here
  doCheck = false;

  meta = {
    homepage = "https://git.taler.net/libeufin.git/";
    description = "Integration and sandbox testing for FinTech APIs and data formats";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ atemu ];
    mainProgram = "libeufin-bank";
  };
}
