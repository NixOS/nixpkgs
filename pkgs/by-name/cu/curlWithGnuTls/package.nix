{
  curl,
  ngtcp2-gnutls,
  ...
}@args:

curl.override (
  {
    gnutlsSupport = true;
    opensslSupport = false;
    ngtcp2 = ngtcp2-gnutls;
  }
  // removeAttrs args [
    "curl"
    "ngtcp2-gnutls"
  ]
)
