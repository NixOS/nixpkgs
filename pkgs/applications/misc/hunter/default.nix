{ lib, stdenv, pkg-config, rustPlatform, fetchFromGitHub, fetchpatch
, makeWrapper, glib, gst_all_1, CoreServices, IOKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "hunter";
  version = "2020-05-25-unstable";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = "hunter";
    rev = "355d9a3101f6d8dc375807de79e368602f1cb87d";
    sha256 = "sha256-R2wNkG8bFP7X2pdlebHK6GD15qmD/zD3L0MwVthvzzQ=";
  };

  patches = [
    (fetchpatch {
      name = "remove-dependencies-on-rust-nightly";
      url = "https://github.com/06kellyjac/hunter/commit/a5943578e1ee679c8bc51b0e686c6dddcf74da2a.diff";
      sha256 = "sha256-eOwBFfW5m8tPnu+whWY/53X9CaqiVj2WRr25G+Yy7qE=";
    })
    (fetchpatch {
      name = "fix-accessing-core-when-moved-with-another-clone";
      url = "https://github.com/06kellyjac/hunter/commit/2e95cc567c751263f8c318399f3c5bb01d36962a.diff";
      sha256 = "sha256-yTzIXUw5qEaR2QZHwydg0abyZVXfK6fhJLVHBI7EAro=";
    })
    (fetchpatch {
      name = "fix-resolve-breaking-changes-from-package-updates";
      url = "https://github.com/06kellyjac/hunter/commit/2484f0db580bed1972fd5000e1e949a4082d2f01.diff";
      sha256 = "sha256-K+WUxEr1eE68XejStj/JwQpMHlhkiOw6PmiSr1GO0kc=";
    })
  ];

  cargoPatches = [
    (fetchpatch {
      name = "chore-cargo-update";
      url = "https://github.com/06kellyjac/hunter/commit/b0be49a82191a4420b6900737901a71140433efd.diff";
      sha256 = "sha256-ctxoDwyIJgEhMbMUfrjCTy2SeMUQqMi971szrqEOJeg=";
    })
    (fetchpatch {
      name = "chore-cargo-upgrade-+-cargo-update";
      url = "https://github.com/06kellyjac/hunter/commit/1b8de9248312878358afaf1dac569ebbccc4321a.diff";
      sha256 = "sha256-+4DZ8SaKwKNmr2SEgJJ7KZBIctnYFMQFKgG+yCkbUv0=";
    })
  ];

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [
    glib
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-bad
  ]) ++ lib.optionals stdenv.isDarwin [ CoreServices IOKit Security ];

  cargoBuildFlags = [ "--no-default-features" "--features=img,video" ];

  postInstall = ''
    wrapProgram $out/bin/hunter --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  cargoSha256 = "sha256-Bd/gilebxC4H+/1A41OSSfWBlHcSczsFcU2b+USnI74=";

  meta = with lib; {
    description = "The fastest file manager in the galaxy!";
    homepage = "https://github.com/rabite0/hunter";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ fufexan ];
    # error[E0308]: mismatched types
    # --> src/files.rs:502:62
    # expected raw pointer `*const u8`, found raw pointer `*const i8`
    broken = stdenv.isAarch64;
  };
}
