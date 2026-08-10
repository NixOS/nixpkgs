{
  curl,
  ...
}@args:

curl.override (
  {
    ldapSupport = true;
    gsaslSupport = true;
    rtmpSupport = true;
    websocketSupport = true;
  }
  // removeAttrs args [ "curl" ]
)
