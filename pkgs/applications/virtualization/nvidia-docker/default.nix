{ stdenv, lib, fetchFromGitHub, fetchpatch, callPackage, makeWrapper
, buildGoPackage, runc, glibc }:

with lib; let

  glibc-ldconf = glibc.overrideAttrs (oldAttrs: {
    # ldconfig needs help reading libraries that have been patchelf-ed, as the
    # .dynstr section is no longer in the first LOAD segment. See also
    # https://sourceware.org/bugzilla/show_bug.cgi?id=23964 and
    # https://github.com/NixOS/patchelf/issues/44
    patches = oldAttrs.patches ++ [ (fetchpatch {
      name = "ldconfig-patchelf.patch";
      url = "https://sourceware.org/bugzilla/attachment.cgi?id=11444";
      sha256 = "0nzzmq7pli37iyjrgcmvcy92piiwjybpw245ds7q43pbgdm7lc3s";
    })];
  });

  libnvidia-container = callPackage ./libnvc.nix { };

  nvidia-container-runtime = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-container-runtime";
    rev = "runtime-v2.0.0";
    sha256 = "0jcj5xxbg7x7gyhbb67h3ds6vly62gx7j02zm6lg102h34jajj7a";
  };

  nvidia-container-runtime-hook = buildGoPackage rec {
    pname = "nvidia-container-runtime-hook";
    version = "1.4.0";

    goPackagePath = "nvidia-container-runtime-hook";

    src = "${nvidia-container-runtime}/hook/nvidia-container-runtime-hook";
  };

  nvidia-runc = runc.overrideAttrs (oldAttrs: rec {
    name = "nvidia-runc";
    version = "1.0.0-rc6";
    src = fetchFromGitHub {
      owner = "opencontainers";
      repo = "runc";
      rev = "v${version}";
      sha256 = "1jwacb8xnmx5fr86gximhbl9dlbdwj3rpf27hav9q1si86w5pb1j";
    };
    patches = [ "${nvidia-container-runtime}/runtime/runc/3f2f8b84a77f73d38244dd690525642a72156c64/0001-Add-prestart-hook-nvidia-container-runtime-hook-to-t.patch" ];
  });

in stdenv.mkDerivation rec {
  pname = "nvidia-docker";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-docker";
    rev = "v${version}";
    sha256 = "1vx5m591mnvcb9vy0196x5lh3r8swjsk0fnlv5h62m7m4m07v6wx";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    mkdir bin
    cp nvidia-docker bin
    cp ${libnvidia-container}/bin/nvidia-container-cli bin
    cp ${nvidia-container-runtime-hook}/bin/nvidia-container-runtime-hook bin
    cp ${nvidia-runc}/bin/runc bin/nvidia-container-runtime
  '';

  installPhase = ''
    mkdir -p $out/{bin,etc}
    cp -r bin $out
    wrapProgram $out/bin/nvidia-container-cli \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:/run/opengl-driver-32/lib
    cp ${./config.toml} $out/etc/config.toml
    substituteInPlace $out/etc/config.toml --subst-var-by glibcbin ${lib.getBin glibc-ldconf}
  '';

  meta = {
    homepage = https://github.com/NVIDIA/nvidia-docker;
    description = "NVIDIA container runtime for Docker";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
