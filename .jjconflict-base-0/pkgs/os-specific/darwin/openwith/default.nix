{
  lib,
  swiftPackages,
  fetchFromGitHub,
}:

let
  inherit (swiftPackages) stdenv swift;
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
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

  makeFlags = [ "openwith_${arch}" ];

  installPhase = ''
    runHook preInstall
    install openwith_${arch} -D $out/bin/openwith
    runHook postInstall
  '';

  meta = with lib; {
    description = "Utility to specify which application bundle should open specific file extensions";
    homepage = "https://github.com/jdek/openwith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ zowoq ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
