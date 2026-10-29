# Validação local de 25/10/2026

O pacote dedicado foi verificado independentemente do restante do Arkhe.

| Gate | Resultado |
|---|---|
| Parser Apex | 8 arquivos aceitos; sem compilação Salesforce |
| XML | 35 documentos parseados e estrutura de Flow conferida |
| Python | 18 testes aprovados; transporte Salesforce simulado |
| Rust | 13 testes aprovados, incluindo versão assinada e recusa de intenção expirada |
| Rustfmt e Clippy | Aprovados; Clippy com warnings como erros |
| Build Rust standalone | Aprovado com lockfile próprio |
| Ensaio CLI real → Python | Assinatura, mapeamento, adulteração, org errada e recuperação após perda de resposta aprovados; CRM simulado |
| Workflows | YAML parseado localmente; sem execução GitHub Actions |

Reprodução: `npm ci --ignore-scripts` e `python scripts/verify_local.py` na raiz
do repositório dedicado. Logs ficam em `evidence/local`, fora de Git. O resumo
versionado e hashes dos logs desta execução ficam em `validation/local/`.

Não foram executados compilação Apex, cobertura na org, medições CPU/heap na
plataforma, probes de permissões/contenção, OAuth real do receptor ou deploy.
Esses gates dependem de configuração e execução no QA designado. O código de
produção permanece sem liberação operacional.
