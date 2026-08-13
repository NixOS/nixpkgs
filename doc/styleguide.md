# Styleguide

## Writing Principles

A consistent style greatly increases the usability of all documentation and communication.

Use this page as a reference and style guide for our internal and external documentation.

### Knowledge Expectations

**Assume competence, not familiarity.**

Write for someone who knows a great deal — up to but not including this project.

**What readers know:**

- Basic computer operation
- Command line familiarity
- General interest in systems configuration

**What readers don't know:**

- NixOS-specific concepts
- NixOS ecosystem details or grammar
- NixOS workflows

If specific knowledge is required, mention it at the start of the page.

#### Show, Don't Tell

The fastest path to understanding is a working example.
People learn by doing, not by reading about doing.

**Recommended structure:**

- Start with the minimal working code or command
- Briefly explain what it does
- Cover edge cases or variations
- Link to further information instead of including it

#### Grammar and Style

**Sentence structure:**

- Use simple, direct sentences
- Break complex ideas into multiple short sentences
- Avoid nested clauses

**Bad:**

> The following command, which utilizes nixos-generate-config to produce a comprehensive hardware configuration, will write the results back into the respective configuration directory located on your local machine.

What the user does is hidden in the middle.
`nixos-generate-config` is a leaked implementation detail.
Users care about *detecting hardware*, not *the tool that does it*.

**Good:**

> This command detects your hardware and saves the configuration.

#### Content Organization

Lead with value. State what the reader will accomplish before explaining how.

**Bad:**

> To create a new NixOS configuration that you can later use as a webserver, first navigate to your project directory, then add a new host configuration file with the desired machine name.

**Good:**

Add a webserver configuration to your NixOS setup:

```nix
# hosts/webserver/configuration.nix
{ ... }:
{
  services.nginx.enable = true;
}
```

Use **progressive disclosure**. Introduce concepts only when needed.

**Recommended structure:**

1. State the goal (one sentence)
2. Show the simplest working example
3. Explain concepts if needed
4. Provide advanced options separately or link to the reference

#### No Meta-commentary

Don't describe what the documentation does. Just do it.

**Don't:**

> This section explains how to configure networking.
> The following guide walks you through setting up a web server.

**Do:**

> Configure networking by setting:
> Set up a web server:

#### Code Examples

**Keep examples focused:**

- Show one concept at a time
- Use realistic but simple scenarios
- Avoid dependencies on other examples

**Minimal comments**

Let the code speak for itself.
Paste code examples directly and without further alteration.

**Bad:**

```nix
# This sets the hostname for the machine
{
  networking.hostName = "webserver"; # Change this to your machine's hostname
  # This enables SSH access
  services.openssh.enable = true; # Required for remote deployment
}
```

**Good:**

```nix
{
  networking.hostName = "webserver";
  services.openssh.enable = true;
}
```

#### Lead with Practical Examples

Don't front-load theory. Readers want to accomplish something first, then understand why it works.

- Show configuration as *what you want*, not *how the module system works*
- Introduce Nix-specific concepts only when they are needed to complete the task
- Defer language mechanics to reference pages or `nix.dev`

**Bad:**

> Before adding a service, you need to understand the NixOS module system and attribute set merging.

**Good:**

Enable nginx:

```nix
{ services.nginx.enable = true; }
```

This adds nginx to your system configuration. Rebuild to apply:

```bash
sudo nixos-rebuild switch
```

#### Teach Nix through examples, not theory


Users learn the NixOS module system by seeing patterns first.

- Start with a working example
- Explanation follows the code
- Link deeper concepts instead of inlining them
- Link to `nix.dev` for optional learning

#### General Rules

- Abbreviate keys like `ssh-ed25519 AAAAC3NzaC…`
- Abbreviate IP addresses like `192.168.XXX.XXX`
- Variables are capitalized and start with `$`, e.g. `$YOUR_HOSTNAME`
- Variables should be directly usable during copy-paste
- Do **not** describe missing code parts (`#elided`, `#omitted`)
- **Machine vs Host**: use "machine" for the NixOS system identity, "host" for the physical or virtual hardware

#### Capitalization

- GB / RAM / HDD
- bootable USB drive
- Wi-Fi / DHCP / DNS
- macOS / NixOS / Nix / Linux
- Flakes
- git

#### Headings

Use sentence case. A reader scanning only headings should understand the page.

**Don't:**

> Getting Started
> Overview
> Configure The Database

**Do:**

> Set up a PostgreSQL database
> Configure networking
> Add a user to the system

#### Imperative Mood, Voice, and Person

Use imperative mood for instructions. Address the reader as "you", not "the user". Use active voice; in other words, make the subject do the action.

**Don't:**

> The user should run the following command.
> The configuration will need to be updated.
> The key is generated by the system.

**Do:**

> Run the command.
> Update the configuration.
> The system generates the key.

#### Tense

Use present tense for descriptions. Future tense makes documentation feel tentative.

**Don't:**

> This will create a new folder.
> Running this command will install the package.

**Do:**

> This creates a new folder.
> Running this command installs the package.

#### Be Confident

State facts. Don't hedge with "should," "might," "typically," or "usually" unless the behavior genuinely varies.

**Don't:**

> This should create the configuration file.
> The service will usually start automatically.

**Do:**

> This creates the configuration file.
> The service starts automatically.

#### Avoid Nominalizations

A nominalization is a verb turned into a noun, often by adding *-tion*, *-meant*, or *-ance* (e.g. "explanation", "selection"). The fix: find the hidden verb and use it directly.

**Don't:**

> Make a selection from the list.
> Provide an explanation of the error.

**Do:**

> Select from the list.
> Explain the error.

#### Plain Words

Technical precision for technical terms; plain language for everything else.

- "use" not "utilize"
- "start" not "initiate"
- "end" not "terminate"
- "help" not "facilitate"
- "send" not "transmit"
- "set up" not "establish"
- "find out" not "ascertain"

#### Filler Words and Weak Phrases

Cut words and phrases that add length without meaning.

Delete on sight:

- "simply", "just", "easily", "basically", "obviously"
- "in order to" → use "to"
- "allows you to" → use the verb directly
- "it's worth noting that" → just say the thing
- no exclamation marks in technical prose

**Don't:**

> Simply run `nixos-rebuild switch`.
> In order to deploy, you first need to run the command, which allows you to push the config.
> It's worth noting that this requires root access.

**Do:**

> Run `nixos-rebuild switch`.
> To deploy, run:
> This requires root access.

Every word must earn its place.

#### Writing Procedures

One instruction per sentence. Don't pack multiple actions into one sentence.

**Don't:**

> Navigate to your project directory and run the command, then check the output.

**Do:**

1. Navigate to your project directory.
2. Run the command.
3. Check the output.

Don't bury the negative. Key limitations should be prominent, not a footnote after a positive description.

**Don't:**

> This service supports multiple roles, integrates with existing modules, and works great for most setups (note that multiple instances are not supported).

**Do:**

> This service does not support multiple instances.

#### Consistent Terminology

Pick a term and stick to it. Don't swap synonyms to avoid repetition. In technical documentation, repetition is clarity.

**Don't:**

> Create a machine... configure the host... deploy the node.

**Do:**

> Create a machine... configure the machine... deploy the machine.

#### Links

Use descriptive link text. Never use "click here" or "this link."

**Don't:**

> For more information, see `[this page](url)`.
> Click `[here](url)` to read the reference.

**Do:**

> See the `[NixOS options reference](url)` for details.
> Read the `[NixOS module system guide](url)`.

Only link when the destination is directly relevant, not for generic background context (sometimes known as "Wikipedia-style links"). Readers feel obligated to click links, fearing they'll miss something important. Don't send them to a generic article about a technology when they're looking for how *your* system uses it.

**Don't:**

> Our software uses [SQLite](https://sqlite.org/) for storage.
> *(Reader clicks expecting schema details — finds a generic product page instead.)*

(Note that in the above example, the SQLite link is the SQLite home page, which is likely not pertinent.)

**Do:**

> See `[database schema](url)` for the full table structure.

#### UI Language

Match UI element names exactly: wording, casing, and spacing (even if a label seems oddly worded).

**Don't:**

> Click the generator button.
> Select the save option.

**Do:**

> Click **Generate a Key**.
> Click **Save Changes**.

Someone will go looking for a button labeled "generator." They will not find it. They will be frustrated.

Consistency between documentation and interface builds confidence. Words are part of the interface.

:::{.tip}
This can be tricky as UI changes; we don't yet have a policy in place for how to handle this. We welcome comments and suggestions.
:::

#### Clean system discipline

Your machine has things new users don't: cached credentials, installed tools, environment variables, existing configuration. When writing or updating documentation:

**Don't:**

> Write steps from memory on your development machine, assuming what works there will work everywhere.

**Do:**

> - Start on a clean system — a fresh VM or new user account
> - Take notes in real time as you work through the steps
> - Document every warning, prompt, or unexpected output the system shows

Also think in combinations: WSL vs native Linux, with and without existing keys. You don't need to test every matrix square — but you need to know which ones diverge.

#### Never type code — always copy-paste

Always copy commands and code from a terminal where you just ran them successfully. Never retype from memory.

**Don't:**

> Retype a command from memory into the documentation.
> Retype code into a code-block from memory

**Do:**

> Paste commands directly from the shell or IDE.
> Paste code that has been successfully validated with nix-instantiate or nix-build

Replace sensitive values with placeholders: `<YOUR-KEY>`, `<YOUR-HOST>`, `<YOUR-TOKEN>`.

Typed-from-memory commands introduce subtle errors. Even the most experienced software developers have occasional typos.
