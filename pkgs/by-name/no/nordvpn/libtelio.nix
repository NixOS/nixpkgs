{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  git,
  protobuf,
  python3,
}:

# Native (Rust) meshnet library consumed by nordvpn-linux's cgo bindings
# (github.com/NordSecurity/libtelio-go), which are already vendored as a Go
# dependency. Only the compiled `libtelio.so` is needed here -- the cgo
# header (telio.h) ships inside the libtelio-go module itself.
let
  # llt-proto's build.rs reads a .proto file from a directory *outside* its
  # own crate (../../ens/ens.proto, relative to the sibling `ens/` dir at
  # the repo root). Cargo's vendoring only ever ships the crate directory
  # itself, so that file goes missing under a vendored/offline build --
  # override the dependency with a full checkout instead (see postPatch).
  llt-proto-src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "llt-proto";
    tag = "v1.0.0";
    hash = "sha256-irjnDEB0cFs0NVqXstokPXiJmcoDZmjt2By4xvjcrdk=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "libtelio";
  version = "6.2.4"; # keep in sync with LIBTELIO_VERSION in nordvpn-linux's lib-versions.env

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libtelio";
    tag = "v${version}";
    hash = "sha256-mnGVkTfpHiig+FnXQivIP+d0AYWZ6z2wu6XcQHP0p1E=";
    # pulls in 3rd-party/rust_build_utils, referenced from build.rs
    fetchSubmodules = true;
  };

  # upstream's own CI build sets this too (ci/build_libtelio.sh) -- skips a
  # git-secrets pre-commit-hook check that's irrelevant to building from a
  # release tarball
  env.BYPASS_LLT_SECRETS = "1";

  postPatch = ''
    cat >> Cargo.toml <<EOF

    [patch."https://github.com/NordSecurity/llt-proto.git"]
    llt-proto = { path = "${llt-proto-src}/rust/llt-proto" }
    EOF
  '';

  cargoHash = "sha256-NpFuGoJ+TYdOIVObV+yro6C1Hsyuh1qGDReJlm/1rwE=";

  # aws-lc-sys (pulled in transitively via rustls) shells out to cmake, and
  # its bindgen build step needs libclang (bindgenHook sets LIBCLANG_PATH).
  # neptun's build.rs shells out to `git log` for a version string (falls
  # back to an empty string harmlessly when not run inside a git checkout).
  # llt-proto (and possibly others) compile .proto files via prost-build,
  # which shells out to `protoc`.
  nativeBuildInputs = [
    cmake
    git
    protobuf
    python3
    rustPlatform.bindgenHook
  ];

  # root package of the workspace is `telio` (the cdylib we need); avoid
  # building the unrelated clis/* workspace members
  buildAndTestSubdir = ".";
  cargoBuildFlags = [
    "-p"
    "telio"
  ];

  # test suite pulls in a lot more (network mocks, etc.); not needed to
  # produce the cdylib we actually want
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$(find target -name libtelio.so -path '*/release/*' | head -1)" -t $out/lib
    runHook postInstall
  '';

  # telio_utils::git::version_tag() reads its version from a 129-byte
  # placeholder baked into the binary at a fixed offset, replaced in place
  # post-build (see ci/insert_libtelio_version.py upstream). Without this,
  # it just logs "VERSION_PLACEHOLDER@@@..." verbatim -- cosmetic only, but
  # replicate it anyway for sane log output.
  postFixup = ''
    python3 -c "
    path = '$out/lib/libtelio.so'
    placeholder = b'VERSION_PLACEHOLDER' + b'@' * 109 + b'\0'
    assert len(placeholder) == 129
    new = ('${version}'.encode() + b'\0' * 129)[:129]
    with open(path, 'r+b') as f:
      data = f.read()
      assert data.count(placeholder) == 1
      f.seek(0)
      f.write(data.replace(placeholder, new))
    "
  '';

  meta = {
    description = "Native meshnet library used by NordVPN's meshnet feature";
    homepage = "https://github.com/NordSecurity/libtelio";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ novalkun ];
    platforms = lib.platforms.linux;
  };
}
