{ pkgconfig, sqlite, openssl, ... }:

{
  libsqlite3-sys = attrs: {
    buildInputs = [ pkgconfig sqlite ];
  };
  openssl-sys = attrs: {
    buildInputs = [ pkgconfig openssl ];
  };
}
