{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "oatpp";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "oatpp";
    repo = "oatpp";
    rev = version;
    sha256 = "sha256-pTQ0DD4naE9m+6FfCVGg/i3WpNbtaR+38yyqjqN0uH0=";
  };

  nativeBuildInputs = [ cmake ];

  # Tests fail on darwin. See https://github.com/NixOS/nixpkgs/pull/105419#issuecomment-735826894
  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    # Copy libraries and headers to standard locations
    cp -r $out/lib/oatpp-1.3.0/* $out/lib/
    cp -r $out/include/oatpp-1.3.0/oatpp/* $out/include/

    # Fix the broken /nix/store/ paths in the cmake output
    for file in $out/lib/cmake/oatpp-1.3.0/*.cmake; do
      sed -i 's|//nix/store/[^/]*/lib/oatpp-1\.3\.0/|"/lib/"|g' "$file"
      sed -i 's|$out/lib/oatpp-1\.3\.0|$out/lib|g' "$file"
      sed -i 's|$out/include/oatpp-1\.3\.0/oatpp|$out/include|g' "$file"
      sed -i 's|lib/oatpp-1\.3\.0|lib|g' "$file"
      sed -i 's|include/oatpp-1\.3\.0/oatpp|include|g' "$file"
      sed -i 's|include/oatpp-1\.3\.0/|include/|g' "$file"
      sed -i 's|$out$out|$out|g' "$file"
      sed -i 's|//|/|g' "$file"
    done
  '';

  meta = with lib; {
    homepage = "https://oatpp.io/";
    description = "Light and powerful C++ web framework for highly scalable and resource-efficient web applications";
    license = licenses.asl20;
    maintainers = [ lib.maintainers.larszauberer ];
    platforms = platforms.all;
  };
}
