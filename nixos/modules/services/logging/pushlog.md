# Pushlog {#module-services-pushlog}

A lightweight Python daemon that filters and forwards journald log messages
to [Pushover](https://pushover.net/).

## Features

- Filter messages by systemd unit name with regex patterns
- Filter messages by priority levels
- Include/exclude messages based on content patterns
- Deduplication with fuzzy matching to avoid notification spam
- Configurable notification batching with timeout window
- Map journald priorities to Pushover priorities

## Configuration

```nix
services.pushlog = {
  enable = true;
  # Load Pushover credentials from an environment file
  # Contains PUSHLOG_PUSHOVER_TOKEN and PUSHLOG_PUSHOVER_USER_KEY
  environmentFile = "/path/to/pushlog.env";

  settings = {
    # Optional Pushover title for all notifications
    title = "System Logs";

    # Optional journald to Pushover priority mapping
    priority-map = {
      "0" = 2;  # emerg -> emergency (2)
      "1" = 1;  # alert -> high (1)
      "2" = 1;  # crit -> high (1)
    };

    # Units to monitor (first match wins, exclude wins over include)
    # Match, include and exclude are regular expressions.
    # Priorities: emerg (0), alert (1), crit (2), err (3),
    #             warning (4), notice (5), info (6), debug (7)
    units = [
      {
        match = "node-red";
        priorities = [ 0 1 2 3 4 5 6 ];
        include = [];
        exclude = [ "[{}]" ];
      }
      {
        match = ".*";
        priorities = [ 0 1 2 3 4 5 6 ];
        include = [ "error" "warning" "critical" ];
        exclude = [];
      }
    ];
  };
};
```

If using agenix for secrets, you can use:

```nix
services.pushlog = {
  enable = true;
  environmentFile = config.age.secrets."pushlog.env".path;
  # ... rest of configuration
};
```
