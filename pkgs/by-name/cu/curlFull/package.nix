{
  curl,
  ...
}@args:

curl.override (
  {
    c-aresSupport = true;
    ldapSupport = true;
    gsaslSupport = true;
    rtmpSupport = true;
    websocketSupport = true;
  }
  // removeAttrs args [ "curl" ]
)
