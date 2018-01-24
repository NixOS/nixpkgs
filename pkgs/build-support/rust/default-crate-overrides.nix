{ pkgconfig, sqlite, openssl, libsodium, ... }:

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
}
