/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   SPDX-FileCopyrightText: 2018 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 */

#ifndef FILEKEEPER_H
#define FILEKEEPER_H

#include <CppJob.h>
#include <DllMacro.h>
#include <utils/PluginFactory.h>

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariantMap>

class PLUGINDLLEXPORT FileKeeperJob : public Calamares::CppJob
{
    Q_OBJECT

public:
    explicit FileKeeperJob( QObject* parent = nullptr );
    virtual ~FileKeeperJob() override;

    QString prettyName() const override;

    Calamares::JobResult exec() override;

    void setConfigurationMap( const QVariantMap& configurationMap ) override;

private:
    QString m_destination;
    QStringList m_files;
};

CALAMARES_PLUGIN_FACTORY_DECLARATION( FileKeeperJobFactory )

#endif
