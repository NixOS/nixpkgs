{
  lib,
  stdenv,
  writableTmpDirAsHomeHook,
  libpng,
  libuuid,
  zlib,
  bzip2,
  xz,
  openssl,
  curl,
  libmysqlclient,
  bash,
  fetchFromGitHub,
  which,
  writeShellScript,
  jq,
  nix-update,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kent";
  version = "488";

  src = fetchFromGitHub {
    owner = "ucscGenomeBrowser";
    repo = "kent";
    tag = "v${finalAttrs.version}_base";
    hash = "sha256-7iapTrQBq0VvbSe+lEdf9lISRJ/uPGdnfjJiSA0NLN8=";
  };

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  buildInputs = [
    libpng
    libuuid
    zlib
    bzip2
    xz
    openssl
    curl
    libmysqlclient
  ];

  postPatch = ''
    substituteInPlace ./src/checkUmask.sh \
      --replace-fail "/bin/bash" "${bash}/bin/bash"

    substituteInPlace ./src/hg/sqlEnvTest.sh \
      --replace-fail "which mysql_config" "${which}/bin/which ${libmysqlclient}/bin/mysql_config"
  '';

  buildPhase = ''
    runHook preBuild

    export MACHTYPE=$(uname -m)
    export CFLAGS="-fPIC"
    export MYSQLINC=$(mysql_config --include | sed -e 's/^-I//g')
    export MYSQLLIBS=$(mysql_config --libs)
    export DESTBINDIR=$HOME/bin

    mkdir -p $HOME/lib $HOME/bin/${stdenv.hostPlatform.parsed.cpu.name}

    cd ./src
    chmod +x ./checkUmask.sh
    ./checkUmask.sh

    make libs
    cd jkOwnLib
    make

    cp ../lib/${stdenv.hostPlatform.parsed.cpu.name}/jkOwnLib.a $HOME/lib
    cp ../lib/${stdenv.hostPlatform.parsed.cpu.name}/jkweb.a $HOME/lib
    cp -r ../inc  $HOME/

    cd ../utils
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/inc
    cp $HOME/lib/jkOwnLib.a $out/lib
    cp $HOME/lib/jkweb.a $out/lib
    cp $HOME/bin/${stdenv.hostPlatform.parsed.cpu.name}/* $out/bin
    cp -r $HOME/inc/* $out/inc/

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-kent" ''
    latestVersion=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/ucscGenomeBrowser/kent/releases/latest | ${lib.getExe jq} --raw-output .tag_name | grep -oP '(?<=v)\d+')
    ${lib.getExe nix-update} kent --version $latestVersion
  '';

  meta = {
    description = "UCSC Genome Bioinformatics Group's suite of biological analysis tools, i.e. the kent utilities";
    homepage = "http://genome.ucsc.edu";
    changelog = "https://github.com/ucscGenomeBrowser/kent/releases/tag/v${finalAttrs.version}_base";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ scalavision ];
    platforms = lib.platforms.linux;
  };
})
