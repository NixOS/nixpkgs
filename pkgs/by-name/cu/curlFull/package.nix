{
  curl,
  ...
}@args:

curl.override (
  {
    c-aresSupport = true;
    ldapSupport = true;
    gsaslSupport = true;
    websocketSupport = true;
  }
  // removeAttrs args [ "curl" ]
)
