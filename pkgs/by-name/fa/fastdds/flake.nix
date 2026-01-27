{
  description = "Fast DDS - eProsima's C++ implementation of DDS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "fastdds";
          version = "3.4.1";

          src = pkgs.fetchFromGitHub {
            owner = "eProsima";
            repo = "Fast-DDS";
            rev = "v3.4.1";
            fetchSubmodules = true;
            hash = "sha256-Qyn3Y1h7egCWxlAIfXae0U7BwMY/qLayjV7QDNhOvJk=";
          };

          patches = [
            ./patches/add-cstdint-include.patch
          ];

          nativeBuildInputs = with pkgs; [
            cmake
            openjdk11
            pkg-config
          ];

          buildInputs = with pkgs; [
            openssl
            asio
            tinyxml-2
            foonathan-memory
            fastcdr
            python3
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DBUILD_SHARED_LIBS=ON"
            "-DSECURITY=ON"
            "-DCOMPILE_EXAMPLES=OFF"
            "-DCMAKE_PREFIX_PATH=${pkgs.foonathan-memory}"
          ];

          meta = {
            description = "Fast RTPS (DDS) is a C++ implementation of the RTPS (Real Time Publish Subscribe) protocol";
            homepage = "https://github.com/eProsima/Fast-DDS";
            license = pkgs.lib.licenses.asl20;
            longDescription = ''
              eProsima Fast RTPS is a C++ implementation of the RTPS (Real Time Publish Subscribe) protocol,
              which provides publisher-subscriber communication over unreliable transports such as UDP,
              as defined and maintained by the Object Management Group (OMG) consortium.
            '';
            platforms = pkgs.lib.platforms.linux;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            openjdk11
            openssl
            asio
            tinyxml-2
            foonathan-memory
            fastcdr
            python3
            pkg-config
            gdb
            ccache
          ];

          shellHook = ''
            echo "Fast DDS development environment loaded"
            echo "Available commands:"
            echo "  cmake . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DSECURITY=ON"
            echo "  cmake --build . -j$(nproc)"
            echo "  cmake --install . --prefix /tmp/fastdds-install"
          '';
        };
      }
    );
}
