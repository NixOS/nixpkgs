{ lib
, fetchFromGitHub
, stdenvNoCC
, mlton
, lua5_3
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  version = "0.2.0";

  pname = "lunarml";

  src = fetchFromGitHub {
    owner = "minoki";
    repo = "LunarML";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-w0DWvFegAdpJTab60cDLA+tketmMYeKApx1rCNr27i4=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [
    mlton
  ];

  nativeCheckInputs = [
    lua5_3
  ];

  postBuild = ''
    make -C thirdparty install
  '';

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $doc/lunarml $out/{bin,lib}
    cp -r bin $out
    cp -r lib $out
    cp -r example $doc/lunarml

    runHook postInstall
  '';

  meta = {
    description = "Standard ML compiler that produces Lua/JavaScript";
    mainProgram = "lunarml";
    homepage = "https://github.com/minoki/LunarML";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ratsclub ];
    platforms = mlton.meta.platforms;
  };
})
