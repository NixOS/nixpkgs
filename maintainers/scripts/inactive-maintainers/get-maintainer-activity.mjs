#!/usr/bin/env nix-shell
/*
#! nix-shell -i zx -p zx
Usage:
./maintainers/scripts/inactive-maintainers/get-maintainer-activity.mjs | tee maintainer_activity.csv
*/
const maintainers = Object.entries(JSON.parse(await $`nix-instantiate --json --strict --eval "${__dirname}/../../maintainer-list.nix"`))
    .map(([name, value]) => ({ name, github: value.github }));

function parse(value) {
    if (value === "") {
        return null;
    } else {
        return JSON.parse(value);
    }
}

async function getPullRequestActivity(githubUsername) {
    try {
        return await $`gh pr list \
            --repo "NixOS/nixpkgs" \
            --author "${githubUsername}" \
            --json createdAt,url \
            --limit 1 \
            --state all \
            --jq ".[] | { "date": .createdAt, url: .url }"`.then(value => parse(value.stdout));
    } catch (error) {
        return null;
    }
}

async function getIssueActivity(githubUsername) {
    try {
        return await $`gh issue list \
            --repo "NixOS/nixpkgs" \
            --author "${githubUsername}" \
            --json createdAt,url \
            --limit 1 \
            --state all \
            --jq ".[] | { "date": .createdAt, url: .url }"`.then(value => parse(value.stdout));
    } catch (error) {
        return null;
    }
}

async function getCommitActivity(githubUsername) {
    try {
        return await $`gh api "repos/NixOS/nixpkgs/commits?author=${githubUsername}&per_page=1"\
            --jq ".[] | { "date": .commit.author.date, "url": .html_url }"`.then(value => parse(value.stdout));
    } catch (error) {
        return null;
    }
}

async function getLatestMaintainerActivity(githubUsername, tries = 3) {
    if (tries == 0) {
        return;
    }
    try {
        const results = await Promise.all([getPullRequestActivity(), getIssueActivity(), getCommitActivity()]);
        let lastActivity = results
            .filter(value => value != null)
            .reduce((prev, current) => prev && Date.parse(prev.date) > Date.parse(current.date) ? prev : current);
        return lastActivity;
    } catch (error) {
        if ((await fetch(`https://api.github.com/users/${githubUsername}`)).status == 404) {
            return "account-deleted";
        }
        await new Promise(resolve => setTimeout(resolve, 1000));
        return await getLatestMaintainerActivity(githubUsername, tries - 1);
    }
}

console.log(`maintainer,githubUsername,activityDate,activityUrl,accountExists`)

let jobs = 0;

async function waitForJob() {
    while (true) {
        if (jobs < 4) {
            return;
        }
        await new Promise(resolve => setTimeout(resolve), 50);
    }
}

for (const maintainer of maintainers) {
    await waitForJob();
    jobs += 1;
    (async () => {
        const result = await getLatestMaintainerActivity(maintainer.github);
        // Account has been renamed or delete
        if (result == "account-deleted") {
            console.log(`${maintainer.name},${maintainer.github},null,null,false`)
        } else if (result != null) {
            // Good result
            console.log(`${maintainer.name},${maintainer.github},${result.date},${result.url},true`)
        } else {
            // some secret third thing (GitHub API 500's)
            console.log(`${maintainer.name},${maintainer.github},null,null,true`)
        }
        jobs -= 1;
    })();
}