{stdenv, fetchurl, sqlite, ruby }:

# Package builds rq with all dependencies into one blob. This to ascertain
# the combination of packages works.

stdenv.mkDerivation {
  name = "rq-3.4.0";
  src = fetchurl {
    url = http://www.codeforpeople.com/lib/ruby/rq/rq-3.4.0.tgz;
    sha256 = "1g8wiv83dcn4vzk9wjjzs9vjnwzwpy4h84h34cj32wfz793wfb8b";
  };

  buildInputs = [ ruby ];

  # patch checks for existing stdin file - sent it upstream
  patches = [ ./rq.patch ];

  buildPhase = ''
    cd all
    ./install.sh $out
    cd ..
  '';

  installPhase = ''
  '';

  meta = {
    license = stdenv.lib.licenses.ruby;
    homepage = "http://www.codeforpeople.com/lib/ruby/rq/";
    description = "Simple cluster queue runner";
    longDescription = "rq creates instant linux clusters by managing priority work queues, even on a multi-core single machine. This cluster runner is easy to install and easy to manage, contrasting with the common complicated solutions.";
    pkgMaintainer = "Pjotr Prins";
    # rq installs a separate Ruby interpreter, which has lower priority
    priority = "10";
  };
}
