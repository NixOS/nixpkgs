{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  libsodium,
  pcre2,
  regexSupport ? false,
  batchSize ? 2048,
}:

stdenv.mkDerivation rec {
  pname = "mkp224o";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cathugger";
    repo = "mkp224o";
    rev = "v${version}";
    sha256 = "sha256-OL3xhoxIS1OqfVp0QboENFdNH/e1Aq1R/MFFM9LNFbQ=";
  };

  buildCommand =
    let
      # compile few variants with different implementation of crypto
      # the fastest depends on a particular cpu
      variants = [
        {
          suffix = "ref10";
          configureFlags = [ "--enable-ref10" ];
        }
        {
          suffix = "donna";
          configureFlags = [ "--enable-donna" ];
        }
      ]
      ++ lib.optionals stdenv.hostPlatform.isx86 [
        {
          suffix = "donna-sse2";
          configureFlags = [ "--enable-donna-sse2" ];
        }
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
        {
          suffix = "amd64-51-30k";
          configureFlags = [ "--enable-amd64-51-30k" ];
        }
        {
          suffix = "amd64-64-24k";
          configureFlags = [ "--enable-amd64-64-24k" ];
        }
      ];
    in
    lib.concatMapStrings (
      { suffix, configureFlags }:
      ''
        install -D ${
          stdenv.mkDerivation {
            pname = "mkp224o-${suffix}";
            inherit version src;
            configureFlags =
              configureFlags
              ++ [ "--enable-batchnum=${builtins.toString batchSize}" ]
              ++ lib.optionals regexSupport [ "--enable-regex=yes" ];
            nativeBuildInputs = [ autoreconfHook ];
            buildInputs = [ libsodium ] ++ lib.optionals regexSupport [ pcre2 ];
            installPhase = "install -D mkp224o $out";
          }
        } $out/bin/mkp224o-${suffix}
      ''
    ) variants;

  meta = with lib; {
    description = "Vanity address generator for tor onion v3 (ed25519) hidden services";
    homepage = "http://cathug2kyi4ilneggumrenayhuhsvrgn6qv2y47bgeet42iivkpynqad.onion/";
    license = licenses.cc0;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
