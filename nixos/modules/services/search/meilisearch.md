# Meilisearch {#module-services-meilisearch}

Meilisearch is a lightweight, fast and powerful search engine. Think elastic search with a much smaller footprint.

## Quickstart {#module-services-meilisearch-quickstart}

the minimum to start meilisearch is

```nix
{
  services.meilisearch.enable = true;
}
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

- Anonymized Analytics sent to meilisearch are disabled by default.

- Default deployment is development mode. It doesn't require a secret master key. All routes are not protected and accessible.

## Missing {#module-services-meilisearch-missing}

- the snapshot feature is not yet configurable from the module, it's just a matter of adding the relevant environment variables.
