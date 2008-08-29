{stdenv, fetchurl, sqlite, ruby }:

stdenv.mkDerivation {
  name = "rq-3.4.0";
  src = fetchurl {
    url = http://www.codeforpeople.com/lib/ruby/rq/rq-3.4.0.tgz;
    sha256 = "1g8wiv83dcn4vzk9wjjzs9vjnwzwpy4h84h34cj32wfz793wfb8b";
  };

  buildInputs = [ ruby ];

  installPhase = "ruby install.rb";
  
  meta = {
    license = "Ruby";
    homepage = "http://www.codeforpeople.com/lib/ruby/rq/";
    description = "rq is a tool used to create instant linux clusters by managing sqlite databases as nfs mounted priority work queues";
  };
}
