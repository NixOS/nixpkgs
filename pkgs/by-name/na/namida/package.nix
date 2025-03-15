{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "namida";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "meew0";
    repo = "namida";
    rev = "782ab6baf679f830c4242bf071d8e85743fe77f7";
    hash = "sha256-pflucKCzfM3Fc2+M8GNq3fsTCln+9bHBGb7/mv/GKVs=";
  };
  cargoHash = "sha256-FT5pxu40A8CSPL0pd1EVK+Ti80F3pdNvh5ojKNlz9Rc=";

  patches = [
    # Needed for rustc/cargo < 1.80
    # std::mem::size_of
    ./client_get_mem_size_of.patch

    # Removes checking git for revision and generating build-time timestamp
    # Provided by environment variables in this nixpkg instead
    ./make_deterministic.patch
  ];

  # Set the git revision and build datetime declaritively
  env = {
    GIT_HASH = src.rev;
    NAMIDA_COMPILE_DT = "1970-01-01 00:00:00";
  };

  meta = {
    description = "Client/server for fast file transfer over high-latency connections via UDP";
    longDescription = ''
      namida is a tool for fast file downloads over high-latency and/or unreliable networks.
      It uses UDP for bulk data transmission, together with a minimal TCP control stream to mediate retransmission of lost data.

      namida is based upon Tsunami, a 2000s-era protocol and software suite for UDP-based file transmission. While Tsunami is still usable today,
      it has essentially not been updated since 2009, and has several problems that make it annoying to use nowadays. So, namida was created by
      first converting Tsunami's source code to Rust using C2Rust, manually converting the generated unsafe code to safe, more idiomatic Rust,
      and then making various improvements.

      In the process some parts of Tsunami were also removed. In particular, after 2006 Tsunami was primarily maintained by Finnish VLBI scientists
      (primarily Jan Wagner at Metsähovi Radio Observatory), who added support for VLBI-specific real-time networking hardware. The project does not
      have access to any of this hardware, so porting is unfeasible. Presumably, the VLBI people are either still happily using Tsunami or have their
      own updated tools anyway.
    '';
    homepage = "https://github.com/meew0/namida";
    license = lib.licenses.free;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ jebriggsy ];
    platforms = lib.platforms.linux;
    mainProgram = "namida";
  };
}
