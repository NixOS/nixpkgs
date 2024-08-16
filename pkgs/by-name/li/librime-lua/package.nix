{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  lua,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-lua";
  version = "0-unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "7be6974b6d81c116bba39f6707dc640f6636fa4e";
    hash = "sha256-jsrnAFE99d0U0LdddTL7G1p416qJfSNR935TZFH3Swk=";
  };

  propagatedBuildInputs = [ lua ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp --archive --verbose src/ $out
    install --mode=644 --verbose --target-directory=$out CMakeLists.txt  LICENSE  README.md

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Extending RIME with Lua scripts";
    homepage = "https://github.com/hchunhui/librime-lua";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ linj xddxdd ];
  };
}
