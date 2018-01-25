{ pkgconfig, sqlite, openssl, libsodium, postgresql, ... }:

{
  libsqlite3-sys = attrs: {
    buildInputs = [ pkgconfig sqlite ];
  };
  openssl-sys = attrs: {
    buildInputs = [ pkgconfig openssl ];
  };
  thrussh-libsodium = attrs: {
    buildInputs = [ pkgconfig libsodium ];
  };
  pq-sys = attr: {
    buildInputs = [ pkgconfig postgresql ];
  };
}
