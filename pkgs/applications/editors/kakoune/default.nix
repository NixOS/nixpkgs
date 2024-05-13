{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "kakoune-unwrapped";
  version = "2024.05.09";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dfp33zk9ZUMrCZRfPNfoSX6rgQKItvOQx+CuRNQgtTA=";
  };
  makeFlags = [ "debug=no" "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    echo "v${finalAttrs.version}" >.version
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kak -ui json -e "kill 0"
  '';

  postInstall = ''
    # make share/kak/autoload a directory, so we can use symlinkJoin with plugins
    cd "$out/share/kak"
    autoload_target=$(readlink autoload)
    rm autoload
    mkdir autoload
    ln -s --relative "$autoload_target" autoload
  '';

  meta = with lib; {
    homepage = "http://kakoune.org/";
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    mainProgram = "kak";
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.unix;
  };
})
