/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#ifndef UNPACKFSC_CONFIG_H
#define UNPACKFSC_CONFIG_H

#include <modulesystem/Config.h>

#include <QList>

struct UnpackEntry
{
    enum class Type
    {
        None,  /// << Invalid
        FSArchive
    };

    QString source;
    QString destination;
    Type type;
};

class Config : public Calamares::ModuleSystem::Config
{
    Q_OBJECT
public:
    Config( QObject* parent = nullptr );
    ~Config() override;

    void setConfigurationMap( const QVariantMap& map ) override;

private:
    QList< UnpackEntry > m_entries;
};

#endif
