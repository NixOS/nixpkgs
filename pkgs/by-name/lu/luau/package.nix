{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gitUpdater,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.667";

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "luau";
    rev = version;
    hash = "sha256-AEPUdqQ+uIWxSTOwwbZ8tWSz3VKKHa1D08o6oeEREkg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.libunwind ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin luau
    install -Dm755 -t $out/bin luau-analyze
    install -Dm755 -t $out/bin luau-compile

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./Luau.UnitTest
    ./Luau.Conformance

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    homepage = "https://luau-lang.org/";
    changelog = "https://github.com/luau-lang/luau/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
    mainProgram = "luau";
  };
}
