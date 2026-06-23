{
  lib,
  fetchFromGitHub,
  melpaBuild,
  nix-update-script,
  stdenv,
  zig_0_15,
  emacs,
  xcbuild,
}:

let
  zig = zig_0_15;

  pname = "ghostel";

  version = "0.35.4-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "dakra";
    repo = "ghostel";
    rev = "adb010b7fec943405006fcd1fac280e74ffa9e30";
    hash = "sha256-OI82g4uMTzlucH9DHNeDl7ppYzpNTjnhZ1SzlRe70Fw=";
  };

  module = stdenv.mkDerivation (finalAttrs: {
    inherit pname version src;

    deps = zig.fetchDeps {
      inherit (finalAttrs) src pname version;
      fetchAll = true;
      hash = "sha256-CTsG3dXu3DECDbklBAtr2fYou82WNvQ1Q3JET0TmuyM=";
    };

    nativeBuildInputs = [ zig ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

    env.EMACS_INCLUDE_DIR = "${emacs}/include";

    dontSetZigDefaultFlags = true;

    doCheck = true;

    zigCheckFlags = [
      "-Dcpu=baseline"
      # See https://github.com/ghostty-org/ghostty/blob/main/PACKAGING.md#build-options
      "-Doptimize=ReleaseFast"
    ];

    zigBuildFlags = finalAttrs.zigCheckFlags;

    postPatch = ''
      # https://github.com/dakra/ghostel/issues/446
      substituteInPlace build.zig \
        --replace-fail 'addInstallFile(version_file, "../ghostel-module.version")' \
                       'addInstallFile(version_file, "ghostel-module.version")'

      # remove copy_step
      substituteInPlace build.zig \
        --replace-fail 'b.getInstallStep().dependOn(&copy_step.step);' ' ' \
        --replace-fail 'const copy_step = b.addInstallFile' \
                       '_ = b.addInstallFile'
    '';

    postConfigure = ''
      cp -rLT ${finalAttrs.deps} "$ZIG_GLOBAL_CACHE_DIR/p"
      chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
    '';
  });

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
melpaBuild {
  inherit pname version src;

  files = ''
    (:defaults "etc" "ghostel-module${libExt}" "ghostel-module.version")
  '';

  preBuild = ''
    install ${module}/lib/libghostel-module${libExt} ghostel-module${libExt}
    install --mode=444 ${module}/ghostel-module.version ghostel-module.version
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

    inherit module;
  };

  meta = {
    homepage = "https://github.com/dakra/ghostel";
    description = "Terminal emulator powered by libghostty";
    maintainers = with lib.maintainers; [ vonfry ];
    license = lib.licenses.gpl3Plus;
  };
}
