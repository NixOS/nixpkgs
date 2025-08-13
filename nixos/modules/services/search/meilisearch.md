# Meilisearch {#module-services-meilisearch}

Meilisearch is a lightweight, fast and powerful search engine. Think elastic search with a much smaller footprint.

## Quickstart {#module-services-meilisearch-quickstart}

the minimum to start meilisearch is

```nix
{ services.meilisearch.enable = true; }
```

this will start the http server included with meilisearch on port 7700.

test with `curl -X GET 'http://localhost:7700/health'`

## Usage {#module-services-meilisearch-usage}

you first need to add documents to an index before you can search for documents.

### Add a documents to the `movies` index {#module-services-meilisearch-quickstart-add}

`curl -X POST 'http://127.0.0.1:7700/indexes/movies/documents' --data '[{"id": "123", "title": "Superman"}, {"id": 234, "title": "Batman"}]'`

### Search documents in the `movies` index {#module-services-meilisearch-quickstart-search}

`curl 'http://127.0.0.1:7700/indexes/movies/search' --data '{ "q": "botman" }'` (note the typo is intentional and there to demonstrate the typo tolerant capabilities)

## Defaults {#module-services-meilisearch-defaults}

- The default nixos package doesn't come with the [dashboard](https://docs.meilisearch.com/learn/getting_started/quick_start.html#search), since the dashboard features makes some assets downloads at compile time.

- `no_analytics` is set to true by default.

- `http_addr` is derived from {option}`services.meilisearch.listenAddress` and {option}`services.meilisearch.listenPort`. The two sub-fields are separate because this makes it easier to consume in certain other modules.

- `db_path` is set to `/var/lib/meilisearch` by default. Upstream, the default value is equivalent to `/var/lib/meilisearch/data.ms`.

- `dump_dir` and `snapshot_dir` are set to `/var/lib/meilisearch/dumps` and `/var/lib/meilisearch/snapshots`, respectively. This is equivalent to the upstream defaults.

- All other options inherit their upstream defaults. In particular, the default configuration uses `env = "development"`, which doesn't require a master key, in which case all routes are unprotected.
