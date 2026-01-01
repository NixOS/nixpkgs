{
  lib,
  swiftPackages,
  fetchFromGitHub,
}:

let
  inherit (swiftPackages) stdenv swift;
  inherit (stdenv.hostPlatform) darwinArch;
in
stdenv.mkDerivation {
  pname = "openwith";
  version = "unstable-2022-10-28";

  src = fetchFromGitHub {
    owner = "jdek";
    repo = "openwith";
    rev = "a8a99ba0d1cabee7cb470994a1e2507385c30b6e";
    hash = "sha256-lysleg3qM2MndXeKjNk+Y9Tkk40urXA2ZdxY5KZNANo=";
  };

  nativeBuildInputs = [ swift ];

  makeFlags = [ "openwith_${darwinArch}" ];

  installPhase = ''
    runHook preInstall
    install openwith_${darwinArch} -D $out/bin/openwith
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Utility to specify which application bundle should open specific file extensions";
    homepage = "https://github.com/jdek/openwith";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ zowoq ];
=======
  meta = with lib; {
    description = "Utility to specify which application bundle should open specific file extensions";
    homepage = "https://github.com/jdek/openwith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ zowoq ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
