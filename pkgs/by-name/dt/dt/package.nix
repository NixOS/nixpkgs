{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_14,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dt";
  version = "1.3.1-unstable-2025-06-20";

  src = fetchFromGitHub {
    owner = "so-dang-cool";
    repo = "dt";
    rev = "7b87e3e012439179772617814cb7d001928d6868";
    hash = "sha256-m3tpnPzgkZw7PR9+bnjbKWcvyfO91F0pucSLRJgiHhw=";
  };

  nativeBuildInputs = [ zig_0_14 ];

  meta = {
    homepage = "https://dt.plumbing";
    description = "Duct tape for your unix pipes";
    longDescription = ''
      dt is a utility and programming language. The utility is intended for
      ergonomic in-the-shell execution. The language is straightforward (in
      the most literal sense) with a minimal syntax that allows for
      high-level, higher-order programming.

      It's meant to supplement (not replace!) other tools like awk, sed,
      xargs, and shell built-ins. Something like the Perl one-liners popular
      yesteryear, but hopefully easier to read and reason through.

      In short, dt is intended to be generally useful, with zero pretense of
      elegance.
    '';
    # TODO: uncomment when dt pushes a new release
    # changelog = "https://github.com/so-dang-cool/dt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ booniepepper ];
    platforms = lib.platforms.unix;
    mainProgram = "dt";
  };
})
