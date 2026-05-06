{
  logstash7,
  ...
}@args:

logstash7.override (
  {
    enableUnfree = false;
  }
  // removeAttrs args [ "logstash7" ]
)
