{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
  nixosTests,
  libssh2,
  pkg-config,
  openssl,
  cmake,
  libgit2,
  icu,
  which,
  file,
  zlib,
  libyaml,
}:

bundlerApp {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

  exes = [
    "oxidized"
    "oxs"
  ];

  gemConfig = {
    rugged = attrs: {
      buildInputs = [
        pkg-config
        cmake
      ];
      nativeBuildInputs = [
        pkg-config
        cmake
      ];
      propagatedBuildInputs = [
        libssh2
        openssl
        libgit2
      ];

      dontUseCmakeConfigure = true;
      buildFlags = [ "--with-ssh" ];
    };

    charlock_holmes = attrs: {
      buildInputs = [
        icu
        zlib
      ];
      nativeBuildInputs = [
        which
        pkg-config
        file
      ];
    };

    psych = attrs: {
      buildInputs = [ libyaml ];
      nativeBuildInputs = [ pkg-config ];
    };
  };

  passthru = {
    tests = nixosTests.oxidized;
    updateScript = bundlerUpdateScript "oxidized";
  };

  meta = {
    description = "Network device configuration backup tool. It's a RANCID replacement";
    homepage = "https://github.com/ytti/oxidized";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nicknovitski
      liberodark
    ];
    teams = with lib.teams; [ wdz ];
    platforms = lib.platforms.linux;
  };
}
