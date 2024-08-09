{ stdenv
, lib
, fetchFromGitHub
, gradle
, jdk17
}:
stdenv.mkDerivation rec {
  pname = "pkl";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl";
    rev = version;
    sha256 = "sha256-Q7B6DRKmgysba+VhvKiTE98UA52i6UUfsvk3Tl/2Rqg=";
    # the build needs the commit id, replace it in postFetch and remove .git manually
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      export commit_id=$(git rev-parse --short HEAD)
      cp ${./set_commit_id.patch} set_commit_id.patch
      chmod +w set_commit_id.patch
      substituteAllInPlace set_commit_id.patch
      git apply set_commit_id.patch
      rm set_commit_id.patch
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-x" "spotlessCheck"
    "-DreleaseBuild=true"
    "-Dorg.gradle.java.home=${jdk17}"
  ];

  JAVA_TOOL_OPTIONS = "-Dfile.encoding=utf-8";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    head -n2 ./pkl-cli/build/executable/jpkl | sed 's%java%${jdk17}/bin/java%' > "$out/bin/pkl"
    tail -n+3 ./pkl-cli/build/executable/jpkl >> "$out/bin/pkl"
    chmod 755 "$out/bin/pkl"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A configuration as code language with rich validation and tooling.";
    homepage = "https://pkl-lang.org/main/current/index.html";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ rafaelrc ];
    mainProgram = "pkl";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
}

