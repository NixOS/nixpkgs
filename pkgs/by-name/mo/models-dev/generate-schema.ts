#!/usr/bin/env bun

// This script was built after:
// https://github.com/anomalyco/models.dev/blob/e19e7c6719650b38712d432760eda2ae3136e796/packages/function/src/worker.ts#L67-L102

import { readFileSync, writeFileSync } from "node:fs";

const [, , apiPath, outPath] = process.argv;

const providers = JSON.parse(readFileSync(apiPath, "utf8")) as Record<
  string,
  { models: Record<string, unknown> }
>;

const modelIds: string[] = [];
for (const [providerId, provider] of Object.entries(providers)) {
  for (const modelId of Object.keys(provider.models)) {
    modelIds.push(`${providerId}/${modelId}`);
  }
}

const schema = {
  $schema: "https://json-schema.org/draft/2020-12/schema",
  $id: "https://models.dev/model-schema.json",
  $defs: {
    Model: {
      type: "string",
      enum: modelIds.sort(),
      description: "AI model identifier in provider/model format",
    },
  },
};

writeFileSync(outPath, `${JSON.stringify(schema, null, 2)}\n`);
